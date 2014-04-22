From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 2/3] crypto: Fix potential leak in test_aead_speed() if crypto_alloc_aead() fails
Date: Wed, 23 Apr 2014 01:35:30 +0200
Message-ID: <201404230135.30918.marex@denx.de>
References: <20140421204439.7999f1c6@spike> <20140421204640.76380365@spike>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christian Engelmayer <cengelma@gmx.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140421204640.76380365@spike>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Monday, April 21, 2014 at 08:46:40 PM, Christian Engelmayer wrote:
> Fix a potential memory leak in the error handling of test_aead_speed(). In
> case crypto_alloc_aead() fails, the function returns without going through
> the centralized cleanup path. Reported by Coverity - CID 1163870.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Looks OK to me, thanks.

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
