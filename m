From: Milos Vyletel <milos.vyletel@gmail.com>
Subject: Re: [PATCH] crypto: x86/sha1: fix coverity CID 1195603
Date: Tue, 6 May 2014 10:04:08 -0400
Message-ID: <CAAFXRd2KGvkEwHUCgQCrvWr8i5eq2dGs-B=HG_-TdSmCi-n8kw@mail.gmail.com>
References: <1398885474-21388-1-git-send-email-milos.vyletel@gmail.com>
	<20140506082846.GB20931@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	"open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>,
	linux-coverity@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140506082846.GB20931@xo-6d-61-c0.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

And this time in plain text...

Most likely yes but I wanted to keep sha1_ssse3_mod_init consistent
with sha256_ssse3_mod_init/sha512_ssse3_mod_init functions.

Milos

On Tue, May 6, 2014 at 4:28 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2014-04-30 15:17:54, Milos Vyletel wrote:
>> Coverity detected possible use of uninitialized pointer when printing info
>> message during module load. While this is higly unlikely to cause any troubles
>> simple change in sha1_ssse3_mod_init to make it look like sha256/512 init
>> function will fix this.
>>
>> 260
>>       6. Condition sha1_transform_asm, taking true branch
>> 261        if (sha1_transform_asm) {
>>
>> CID 1195603 (#1 of 1): Uninitialized pointer read (UNINIT)
>> 7. uninit_use_in_call: Using uninitialized value algo_name when calling printk.
>> 262                pr_info("Using %s optimized SHA-1 implementation\n", algo_name);
>> 263                return crypto_register_shash(&alg);
>> 264        }
>>
>> Reported-by: <scan-admin@coverity.com>
>> Signed-off-by: Milos Vyletel <milos.vyletel@gmail.com>
>> ---
>>  arch/x86/crypto/sha1_ssse3_glue.c | 22 ++++++++++++----------
>>  1 file changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
>> index 74d16ef..5352196 100644
>> --- a/arch/x86/crypto/sha1_ssse3_glue.c
>> +++ b/arch/x86/crypto/sha1_ssse3_glue.c
>> @@ -235,31 +235,33 @@ static bool __init avx2_usable(void)
>>
>>  static int __init sha1_ssse3_mod_init(void)
>>  {
>> -     char *algo_name;
>> -
>
> Would simple "algo_name = NULL" be enough to fix this?
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
