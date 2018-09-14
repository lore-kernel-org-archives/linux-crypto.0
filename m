From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: Adds user space interface for ALG_SET_KEY_TYPE
Date: Fri, 14 Sep 2018 14:03:11 +0800
Message-ID: <20180914060311.hxngp42bogbabpkd@gondor.apana.org.au>
References: <1536302443-18380-1-git-send-email-kalyani.akula@xilinx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, kstewart@linuxfoundation.org,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        pombredanne@nexb.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        saratcha@xilinx.com, kalyani.akula@xilinx.com
To: Kalyani Akula <kalyani.akula@xilinx.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536302443-18380-1-git-send-email-kalyani.akula@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Kalyani Akula <kalyani.akula@xilinx.com> wrote:
> ALG_SET_KEY_TYPE requires caller to pass the key_type to be used
> for AES encryption/decryption.
> 
> Sometimes the cipher key will be stored in the device's
> hardware (eFuse, BBRAM etc).So,there is a need to specify the information
> about the key-type to use it for Encrypt or Decrypt operations.
> 
> This patch implements the above requirement.
> 
> 
> Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>

This patch does not make sense by itself.  Please post it together
with the patches that will make use of this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
