From: Halil Pasic <pasic@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 2/2] crypto: add virtio-crypto driver
Date: Tue, 13 Dec 2016 17:11:34 +0100
Message-ID: <b55a4666-d71a-352c-8be3-286eef6c5bc0@linux.vnet.ibm.com>
References: <1481171829-116496-1-git-send-email-arei.gonglei@huawei.com>
	<1481171829-116496-3-git-send-email-arei.gonglei@huawei.com>
	<33183CC9F5247A488A2544077AF19020DA15A07C@DGGEMA505-MBX.china.huawei.com>
	<20161212105407.GA3033@gondor.apana.org.au>
	<20161212234941-mutt-send-email-mst@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
	"Xuquan \(Quan Xu\)" <xuquan8@huawei.com>,
	"Huangweidong \(C\)" <weidong.huang@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Claudio Fontana <Claudio.Fontana@huawei.com>,
	"Hanweidong \(Randy\)" <hanweidong@huawei.com>,
	Luonengjun <luonengjun@huawei.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
	"Wanzongshun \(Vincent\)" <wanzongshun@huawei.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"stefanha@redhat.com" <stefanha@redhat.com>, "Zhoujian \(jay,
	Euler\)" <jianjay.zhou@huawei.com>, longpeng <longpeng2@huawei.com>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"Wubin \(H\)" <
To: "Gonglei (Arei)" <arei.gonglei@huawei.com>
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20161212234941-mutt-send-email-mst@kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
List-Id: linux-crypto.vger.kernel.org



On 12/12/2016 11:05 PM, Michael S. Tsirkin wrote:
> On Mon, Dec 12, 2016 at 06:54:07PM +0800, Herbert Xu wrote:
>> On Mon, Dec 12, 2016 at 06:25:12AM +0000, Gonglei (Arei) wrote:
>>> Hi, Michael & Herbert
>>>
>>> Because the virtio-crypto device emulation had been in QEMU 2.8,
>>> would you please merge the virtio-crypto driver for 4.10 if no other
>>> comments? If so, Miachel pls ack and/or review the patch, then
>>> Herbert will take it (I asked him last week). Thank you!
>>>
>>> Ps: Note on 4.10 merge window timing from Linus
>>>  https://lkml.org/lkml/2016/12/7/506
>>>
>>> Dec 23rd is the deadline for 4.10 merge window.
>>
>> Sorry but it's too late for 4.10.  It needed to have been in my
>> tree before the merge window opened to make it for this cycle.
>>
>> Cheers,
> 
> 
> Objections to me merging this? I'm preparing my tree right now.

Got this when testing the most recent version on s390x 

[   20.391074] test 0 (128 bit key, 16 byte blocks): [   20.391078] BUG: using smp_processor_id() in preemptible [00000000] code: insmod/97
[   20.391082] caller is virtio_crypto_ablkcipher_setkey+0x44/0x198
[   20.391085] CPU: 0 PID: 97 Comm: insmod Not tainted 4.9.0-02683-gb62a1ab #46
[   20.391088] Hardware name: IBM              2964 NC9              704              (KVM)
[   20.391405] Stack:
[   20.391407]        000000000c0eb6d0 000000000c0eb760 0000000000000003 0000000000000000
[   20.391414]        000000000c0eb800 000000000c0eb778 000000000c0eb778 0000000000000020
[   20.391420]        0000000000000000 000000000000000a 0000000000000020 000003ff0000000a
[   20.391426]        000003ff0000000c 000000000c0eb7c8 0000000000000000 0000000000000000
[   20.391432]        0700000000c173c8 00000000001126ba 000000000c0eb760 000000000c0eb7b8
[   20.391439] Call Trace:
[   20.391442] ([<000000000011259e>] show_trace+0x8e/0xe0)
[   20.391446]  [<0000000000112670>] show_stack+0x80/0xd8 
[   20.391449]  [<0000000000753ab6>] dump_stack+0x96/0xd8 
[   20.391453]  [<00000000007872e6>] check_preemption_disabled+0xfe/0x128 
[   20.391456]  [<0000000000839cc4>] virtio_crypto_ablkcipher_setkey+0x44/0x198 
[   20.391459]  [<0000000000705a40>] skcipher_setkey_ablkcipher+0x50/0x70 
[   20.391476]  [<000003ff80002a48>] test_skcipher_speed+0x328/0xb98 [tcrypt] 
[   20.391492]  [<000003ff800063dc>] do_test+0x1c24/0x28e0 [tcrypt] 
[   20.391509]  [<000003ff8001006a>] tcrypt_mod_init+0x6a/0x1000 [tcrypt] 
[   20.391512]  [<00000000001002cc>] do_one_initcall+0xb4/0x148 
[   20.391515]  [<0000000000298632>] do_init_module+0x7a/0x228 
[   20.391519]  [<00000000001fd380>] load_module+0x2428/0x2de0 
[   20.391522]  [<00000000001fde8a>] SyS_init_module+0x152/0x160 
[   20.391526]  [<00000000009f1306>] system_call+0xd6/0x270 
[   20.391528] no locks held by insmod/97.

Gonglei, any idea? Did not look into it myself yet.

Halil

> 
>> -- 
>> Email: Herbert Xu <herbert@gondor.apana.org.au>
>> Home Page: http://gondor.apana.org.au/~herbert/
>> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 
