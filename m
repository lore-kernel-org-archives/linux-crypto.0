From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 3/3] crypto: Fix leak of struct aead_request in test_aead_speed()
Date: Wed, 23 Apr 2014 01:36:25 +0200
Message-ID: <201404230136.26053.marex@denx.de>
References: <20140421204439.7999f1c6@spike> <20140421204705.07cb8278@spike>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christian Engelmayer <cengelma@gmx.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140421204705.07cb8278@spike>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Monday, April 21, 2014 at 08:47:05 PM, Christian Engelmayer wrote:
> Fix leakage of memory for struct aead_request that is allocated via
> aead_request_alloc() but not released via aead_request_free().
> Reported by Coverity - CID 1163869.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
