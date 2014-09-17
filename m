From: Behan Webster <behanw@converseincode.com>
Subject: Re: [PATCH v3 01/12] crypto: LLVMLinux: Add macro to remove use of
 VLAIS in crypto code
Date: Wed, 17 Sep 2014 08:26:19 -0700
Message-ID: <5419A81B.2030705@converseincode.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com> <1410766234-1634-2-git-send-email-behanw@converseincode.com> <20140917092212.GA1213@gondor.apana.org.au> <54196D5C.6040104@samsung.com> <20140917113035.GB2129@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
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
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20140917113035.GB2129@gondor.apana.org.au>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/17/14 04:30, Herbert Xu wrote:
> On Wed, Sep 17, 2014 at 02:15:40PM +0300, Dmitry Kasatkin wrote:
>> On 17/09/14 12:22, Herbert Xu wrote:
>>> On Mon, Sep 15, 2014 at 12:30:23AM -0700, behanw@converseincode.com=
 wrote:
>>>> From: Behan Webster <behanw@converseincode.com>
>>>>
>>>> Add a macro which replaces the use of a Variable Length Array In S=
truct (VLAIS)
>>>> with a C99 compliant equivalent. This macro instead allocates the =
appropriate
>>>> amount of memory using an char array.
>>>>
>>>> The new code can be compiled with both gcc and clang.
>>>>
>>>> struct shash_desc contains a flexible array member member ctx decl=
ared with
>>>> CRYPTO_MINALIGN_ATTR, so sizeof(struct shash_desc) aligns the begi=
nning
>>>> of the array declared after struct shash_desc with long long.
>>>>
>>>> No trailing padding is required because it is not a struct type th=
at can
>>>> be used in an array.
>>>>
>>>> The CRYPTO_MINALIGN_ATTR is required so that desc is aligned with =
long long
>>>> as would be the case for a struct containing a member with
>>>> CRYPTO_MINALIGN_ATTR.
>>>>
>>>> Signed-off-by: Behan Webster <behanw@converseincode.com>
>>> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>>>
>>> Thanks,
>> Just in case.
>> I would still follow advice from "Micha=C5=82 Miros=C5=82aw" to use =
shash##__desc[]
Absolutely. I will be posting a v4 patchset . Just waiting a bit more=20
for more comments on v3.

The macro from v4 will look like this which I believe will satisfy the=20
concern and indeed be safer than my previous version.

+#define SHASH_DESC_ON_STACK(shash, tfm)                               =
   \
+       char __##shash##_desc[sizeof(struct shash_desc) +        \
+               crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR; \
+       struct shash_desc *shash =3D (struct shash_desc *)__##shash##_d=
esc

Hmm. Is it worth adding a comment with this macro explaining the reason=
 this works? Essentially much of what is in the commit message?
 =20

> Oh yes of course.  My ack is more about the approach.

Wonderful!

Indeed. I would have asked for you to wait for v4 anyways. :)

Thank you,

Behan

--=20
Behan Webster
behanw@converseincode.com

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
