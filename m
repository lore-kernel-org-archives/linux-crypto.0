From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] kernel crypto API interface specification
Date: Tue, 14 Oct 2014 22:00:37 +0200
Message-ID: <2178720.yAoRcDWDgu@myon.chronox.de>
References: <7502136.9BkWHTZ0th@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7502136.9BkWHTZ0th@myon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 14. Oktober 2014, 21:46:50 schrieb Stephan Mueller:

Hi,

> The update adds a complete interface documentation of the kernel crypto
> API. All cipher types supported by the kernel crypto API are documented.
> 
> In addition, kernel and user space example code is provided. The sample
> code covers synchronous and asynchronous cipher operation, random
> number generation and performing hashing as well as encryption and
> decryption in user space.

I was not sure whether to cover the explanation of the API in a separate 
document or whether to add the function documentation to 
include/linux/crypto.h.

With the first attempt of the documentation, I applied the least invasive 
approach. If it is requested, I would modify the patch such that appropriate 
source code comments to the functions in the header file are added.

-- 
Ciao
Stephan
