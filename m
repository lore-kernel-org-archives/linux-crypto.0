From: Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: Re: [PATCH v3 01/12] crypto: LLVMLinux: Add macro to remove use of
 VLAIS in crypto code
Date: Wed, 17 Sep 2014 14:15:40 +0300
Message-ID: <54196D5C.6040104@samsung.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
 <1410766234-1634-2-git-send-email-behanw@converseincode.com>
 <20140917092212.GA1213@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: agk@redhat.com, clm@fb.com, davem@davemloft.net,
	dm-devel@redhat.com, fabf@skynet.be, jbacik@fb.com,
	snitzer@redhat.com, tadeusz.struk@intel.com,
	akpm@linux-foundation.org, bruce.w.allan@intel.com,
	james.l.morris@oracle.com, john.griffin@intel.com,
	linux-btrfs@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, linux-security-module@vger.kernel.org,
	neilb@suse.de, qat-linux@intel.com, serge@hallyn.com,
	thomas.lendacky@amd.com, zohar@linux.vnet.ibm.com,
	torvalds@linux-foundation.org
To: Herbert Xu <herbert@gondor.apana.org.au>, behanw@converseincode.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20140917092212.GA1213@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 17/09/14 12:22, Herbert Xu wrote:
> On Mon, Sep 15, 2014 at 12:30:23AM -0700, behanw@converseincode.com w=
rote:
>> From: Behan Webster <behanw@converseincode.com>
>>
>> Add a macro which replaces the use of a Variable Length Array In Str=
uct (VLAIS)
>> with a C99 compliant equivalent. This macro instead allocates the ap=
propriate
>> amount of memory using an char array.
>>
>> The new code can be compiled with both gcc and clang.
>>
>> struct shash_desc contains a flexible array member member ctx declar=
ed with
>> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the beginn=
ing
>> of the array declared after struct shash_desc with long long.
>>
>> No trailing padding is required because it is not a struct type that=
 can
>> be used in an array.
>>
>> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with lo=
ng long
>> as would be the case for a struct containing a member with
>> CRYPTO_MINALIGN_ATTR.
>>
>> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> Thanks,

Just in case.
I would still follow advice from "Micha=C5=82 Miros=C5=82aw" to use sha=
sh##__desc[]

- Dmitry
