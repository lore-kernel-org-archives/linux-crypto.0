From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: aead - move aead_request_cast helper to aead.h
Date: Mon, 1 Feb 2016 07:46:59 -0800
Message-ID: <56AF7DF3.1010305@intel.com>
References: <20160127220916.12466.99501.stgit@tstruk-mobl1>
 <20160201094633.GA6299@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: smueller@chronox.de, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160201094633.GA6299@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/01/2016 01:46 AM, Herbert Xu wrote:
>> Move the helper function to common header for everybody to use.
>> > 
>> > Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> This should go into internal/aead.h if at all.

Yes, I though about it, but I followed skcipher. The skcipher_request_cast()
helper is in crypto/skcipher.h not in crypto/internal/skcipher.h
Shouldn't this be consistent?
Thanks,

-- 
TS
