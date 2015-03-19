From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v2 5/5] crypto: talitos: Add software backlog queue handling
Date: Thu, 19 Mar 2015 17:56:57 +0200
Message-ID: <550AF1C9.9090500@freescale.com>
References: <1425388897-5434-1-git-send-email-mort@bork.org>
	<1425388897-5434-6-git-send-email-mort@bork.org>
	<20150303182332.546523088b5891a776880c0f@freescale.com>
	<5506AA4B.303@freescale.com>
	<20150316191935.81f89e0dafebbbe76ffcb0c0@freescale.com>
	<55086B5F.9080906@freescale.com>
 <20150317170319.1e4cd2b1d1450b442a3b3b36@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "David S. Miller" <davem@davemloft.net>,
	Martin Hicks <mort@bork.org>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-crypto@vger.kernel.org>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0102.outbound.protection.outlook.com ([157.56.111.102]:42563
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbbCSP5M (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Mar 2015 11:57:12 -0400
In-Reply-To: <20150317170319.1e4cd2b1d1450b442a3b3b36@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/18/2015 12:03 AM, Kim Phillips wrote:
> On Tue, 17 Mar 2015 19:58:55 +0200
> Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:
>=20
>> On 3/17/2015 2:19 AM, Kim Phillips wrote:
>>> On Mon, 16 Mar 2015 12:02:51 +0200
>>> Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:
>>>
>>>> On 3/4/2015 2:23 AM, Kim Phillips wrote:
>>>>> Only potential problem is getting the crypto API to set the GFP_D=
MA
>>>>> flag in the allocation request, but presumably a
>>>>> CRYPTO_TFM_REQ_DMA crt_flag can be made to handle that.
>>>>
>>>> Seems there are quite a few places that do not use the
>>>> {aead,ablkcipher_ahash}_request_alloc() API to allocate crypto req=
uests.
>>>> Among them, IPsec and dm-crypt.
>>>> I've looked at the code and I don't think it can be converted to u=
se
>>>> crypto API.
>>>
>>> why not?
>>
>> It would imply having 2 memory allocations, one for crypto request a=
nd
>> the other for the rest of the data bundled with the request (for IPs=
ec
>> that would be ESN + space for IV + sg entries for authenticated-only
>> data and sk_buff extension, if needed).
>>
>> Trying to have a single allocation by making ESN, IV etc. part of th=
e
>> request private context requires modifying tfm.reqsize on the fly.
>> This won't work without adding some kind of locking for the tfm.
>=20
> can't a common minimum tfm.reqsize be co-established up front, at
> least for the fast path?

Indeed, for IPsec at tfm allocation time - esp_init_state() -
tfm.reqsize could be increased to account for what is known for a given
flow: ESN, IV and asg (S/G entries for authenticated-only data).
The layout would be:
aead request (fixed part)
private ctx of backend algorithm
seq_no_hi (if ESN)
IV
asg
sg <-- S/G table for skb_to_sgvec; how many entries is the question

Do you have a suggestion for how many S/G entries to preallocate for
representing the sk_buff data to be encrypted?
An ancient esp4.c used ESP_NUM_FAST_SG, set to 4.
Btw, currently maximum number of fragments supported by the net stack
(MAX_SKB_FRAGS) is 16 or more.

>>>> This means that the CRYPTO_TFM_REQ_DMA would be visible to all of =
these
>>>> places. Some of the maintainers do not agree, as you've seen.
>>>
>>> would modifying the crypto API to either have a different
>>> *_request_alloc() API, and/or adding calls to negotiate the GFP mas=
k
>>> between crypto users and drivers, e.g., get/set_gfp_mask, work?
>>
>> I think what DaveM asked for was the change to be transparent.
>>
>> Besides converting to *_request_alloc(), seems that all other option=
s
>> require some extra awareness from the user.
>> Could you elaborate on the idea above?
>=20
> was merely suggesting communicating GFP flags anonymously across the
> API, i.e., GFP_DMA wouldn't appear in user code.

Meaning user would have to get_gfp_mask before allocating a crypto
request - i.e. instead of kmalloc(..., GFP_ATOMIC) to have
kmalloc(GFP_ATOMIC | get_gfp_mask(aead))?

>>>> An alternative would be for talitos to use the page allocator to g=
et 1 /
>>>> 2 pages at probe time (4 channels x 32 entries/channel x 64B/descr=
iptor
>>>> =3D 8 kB), dma_map_page the area and manage it internally for tali=
tos_desc
>>>> hw descriptors.
>>>> What do you think?
>>>
>>> There's a comment in esp_alloc_tmp(): "Use spare space in skb for
>>> this where possible," which is ideally where we'd want to be (esp.
>>
>> Ok, I'll check that. But note the "where possible" - finding room in=
 the
>> skb to avoid the allocation won't always be the case, and then we're
>> back to square one.

So the skb cb is out of the question, being too small (48B).
Any idea what was the intention of the "TODO" - maybe to use the
tailroom in the skb data area?

>>> because that memory could already be DMA-able).  Your above
>>> suggestion would be in the opposite direction of that.
>>
>> The proposal:
>> -removes dma (un)mapping on the fast path
>=20
> sure, but at the expense of additional complexity.

Right, there's no free lunch. But it's cheaper.

>> -avoids requesting dma mappable memory for more than it's actually
>> needed (CRYPTO_TFM_REQ_DMA forces entire request to be mappable, not
>> only its private context)
>=20
> compared to the payload?  Plus, we have plenty of DMA space these
> days.
>=20
>> -for caam it has the added benefit of speeding the below search for =
the
>> offending descriptor in the SW ring from O(n) to O(1):
>> for (i =3D 0; CIRC_CNT(head, tail + i, JOBR_DEPTH) >=3D 1; i++) {
>> 	sw_idx =3D (tail + i) & (JOBR_DEPTH - 1);
>>
>> 	if (jrp->outring[hw_idx].desc =3D=3D
>> 	    jrp->entinfo[sw_idx].desc_addr_dma)
>> 		break; /* found */
>> }
>> (drivers/crypto/caam/jr.c - caam_dequeue)
>=20
> how?  The job ring h/w will still be spitting things out
> out-of-order.

jrp->outring[hw_idx].desc bus address can be used to find the sw_idx in
O(1):

dma_addr_t desc_base =3D dma_map_page(alloc_page(GFP_DMA),...);
[...]
sw_idx =3D (desc_base - jrp->outring[hw_idx].desc) / JD_SIZE;

JD_SIZE would be 16 words (64B) - 13 words used for the h/w job
descriptor, 3 words can be used for smth. else.
Basically all JDs would be filled at a 64B-aligned offset in the memory
page.

> Plus, like I said, it's taking the problem in the wrong direction:
> we need to strive to merge the allocation and mapping with the upper
> layers as much as possible.

IMHO propagating the GFP_DMA from backend crypto implementations to
crypto API users doesn't seem feasable.
It's error-prone to audit all places that allocate crypto requests w/ou=
t
using *_request_alloc API.
And even if all these places would be identified:
-in some cases there's some heavy rework involved
-more places might show up in the future and there's no way to detect t=
hem

Horia
