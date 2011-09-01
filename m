From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: comparison of the AF_ALG interface with the /dev/crypto
Date: Thu, 01 Sep 2011 08:54:19 +0200
Message-ID: <4E5F2C1B.1040406@gnutls.org>
References: <20110901021534.GA26330@gondor.apana.org.au> <4E5F257F.9060202@gnutls.org> <20110901064319.GB27893@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: cryptodev-linux-devel@gna.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110901064319.GB27893@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 09/01/2011 08:43 AM, Herbert Xu wrote:
> On Thu, Sep 01, 2011 at 08:26:07AM +0200, Nikos Mavrogiannopoulos wrote:
>>
>> Actually this is the reason of the ecb(cipher-null) comparison. To
>> emulate the case of a hardware offload device. I tried to make that
>> clear in the text, but may not be. If you see AF_ALG performs really bad
>> on that case. It performs better when a software or a padlock
>> implementation of AES is involved (which as you say it is a useless
>> use-case).
> It's meaningless because such devices operate at a rate much
> lower than the figures you give.

Have you actually measured that?
