From: Anatoly Pugachev <matorola@gmail.com>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Wed, 4 May 2016 22:10:47 +0300
Message-ID: <CADxRZqzynaTAD+vcJwW2ueGnQyy=tQAJq2TvTT-_pZG26=_ZLQ@mail.gmail.com>
References: <CADxRZqyMwme53etMrnx3xkpGsR6-W88RHLA3nh0GCGAzcz5=Fw@mail.gmail.com>
	<20160503.123301.298039059390449291.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20160503.123301.298039059390449291.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 3, 2016 at 7:33 PM, David Miller <davem@davemloft.net> wrote:
> From: Anatoly Pugachev <matorola@gmail.com>
> Date: Tue, 3 May 2016 16:54:18 +0300
>
>> I have git kernel OOPS (4.6.0-rc6) on sparc64. This OOPS does not
>> happen, if I set the following kernel option:
>>
>> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
>>
>> Can someone please look at https://bugzilla.kernel.org/show_bug.cgi?id=117551 ?
>
> The lib/mpi/ code hasn't been touched in a long time, so I can only see that it might
> be the crypto/rsa.c changes that happened this release.
>
> Can you possibly bisect this or at least tell us that 4.5 doesn't have this problem?

David,

we're using 4.5.2 debian kernel here without this problem. I'm not
sure I would be able to bisect, never did it before, but I could
try...

Here's a quick diff related to crypto for debian kernel configs:

$ diff -u /boot/config-4.5.0-2-sparc64-smp /boot/config-4.6.0-rc5-sparc64-smp
@@ -5299,10 +5380,9 @@
 CONFIG_CRYPTO_RNG=m
 CONFIG_CRYPTO_RNG2=y
 CONFIG_CRYPTO_RNG_DEFAULT=m
-CONFIG_CRYPTO_PCOMP=m
-CONFIG_CRYPTO_PCOMP2=y
 CONFIG_CRYPTO_AKCIPHER2=y
-# CONFIG_CRYPTO_RSA is not set
+CONFIG_CRYPTO_AKCIPHER=y
+CONFIG_CRYPTO_RSA=y
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_MANAGER2=y
 # CONFIG_CRYPTO_USER is not set

so, I need to compile 4.5.x kernel (or even older kernels) with
CRYPTO_RSA=y and test how it would act. And if it would not crash, I
could try to bisect.

Thanks.
