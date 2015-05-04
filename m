From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 1/2] crypto: add PKE API
Date: Mon, 04 May 2015 12:26:40 -0700
Message-ID: <5547C7F0.5010905@intel.com>
References: <20150430223652.10157.86151.stgit@tstruk-mobl1> <20150430223647.10157.82156.stgit@tstruk-mobl1> <4227.1430496240@warthog.procyon.org.uk> <5543C348.9060004@intel.com> <20150503000744.GB16211@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: David Howells <dhowells@redhat.com>, corbet@lwn.net,
	keescook@chromium.org, qat-linux@intel.com, jwboyer@redhat.com,
	richard@nod.at, linux-kernel@vger.kernel.org, steved@redhat.com,
	vgoyal@redhat.com, james.l.morris@oracle.com, jkosina@suse.cz,
	zohar@linux.vnet.ibm.com, davem@davemloft.net,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150503000744.GB16211@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 05/02/2015 05:07 PM, Herbert Xu wrote:
>>>> > >>  #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
>>>>> > >> > +#define CRYPTO_ALG_TYPE_PKE		0x0000000b
>>>>> > >> >  #define CRYPTO_ALG_TYPE_RNG		0x0000000c
>>> > > Will filling a hole cause a problem with something that got obsoleted?
>> > 
>> > I hope not. I checked as far back as 2.6.18 and I don't see any clash.
>> > Herbert, what do you think?
> Indeed you can't use this hole as it'll make you a hash algorithm.

So in this case isn't RNG a hash algorithm as well?
Anyway will something like this be ok with you:

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ee14140..ac18cd3 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -41,7 +41,7 @@
 /*
  * Algorithm masks and types.
  */
-#define CRYPTO_ALG_TYPE_MASK           0x0000000f
+#define CRYPTO_ALG_TYPE_MASK           0xf000000f
 #define CRYPTO_ALG_TYPE_CIPHER         0x00000001
 #define CRYPTO_ALG_TYPE_COMPRESS       0x00000002
 #define CRYPTO_ALG_TYPE_AEAD           0x00000003
@@ -54,6 +54,7 @@
 #define CRYPTO_ALG_TYPE_AHASH          0x0000000a
 #define CRYPTO_ALG_TYPE_RNG            0x0000000c
 #define CRYPTO_ALG_TYPE_PCOMPRESS      0x0000000f
+#define CRYPTO_ALG_TYPE_PKE            0x10000001
 
 #define CRYPTO_ALG_TYPE_HASH_MASK      0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK     0x0000000c
