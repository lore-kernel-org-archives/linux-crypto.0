From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: Linux 3.6-rc5
Date: Sun, 09 Sep 2012 23:26:04 +0300
Message-ID: <20120909232604.342762ujqb3iewow@www.81.fi>
References: <CA+55aFwnPfdyTTG6WTuhChomg=t9nSS18xracq3iQ3F5+PWOog@mail.gmail.com>
 <87har7h84h.fsf@silenus.orebokech.com>
 <20120909191958.GB9782@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Romain Francoise <romain@orebokech.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120909191958.GB9782@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Quoting Herbert Xu <herbert@gondor.apana.org.au>:

>
> Can you try blacklisting/not loading sha1_ssse3 and aesni_intel
> to see which one of them is causing this crash? Of course if you
> can still reproduce this without loading either of them that would
> also be interesting to know.

This triggers with aes-x86_64 and sha1_generic (and sha256 & sha512)  
too, with following test added to tcrypt:
         case 46:
                 ret += tcrypt_test("authenc(hmac(sha1),cbc(aes))");
                 ret += tcrypt_test("authenc(hmac(sha256),cbc(aes))");
                 ret += tcrypt_test("authenc(hmac(sha512),cbc(aes))");
                 break;

-Jussi

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
