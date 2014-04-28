From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] staging: crypto: skein: depend upon CRYPTO
Date: Mon, 28 Apr 2014 23:38:19 +0200
Message-ID: <201404282338.19758.marex@denx.de>
References: <20140425151554.GB31117@localhost> <1398444309-24672-1-git-send-email-jason@lakedaemon.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
	Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1398444309-24672-1-git-send-email-jason@lakedaemon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday, April 25, 2014 at 06:45:09 PM, Jason Cooper wrote:
> Fengguang's randconfig kernel build tester discovered the following
> warnings:
> 
> warning: (CRYPTO_THREEFISH) selects CRYPTO_ALGAPI which has unmet direct
> dependencies (CRYPTO) warning: (DM_VERITY && CRYPTO_SKEIN) selects
> CRYPTO_HASH which has unmet direct dependencies (CRYPTO)
> 
> Fix this in the Kconfig by depending on CRYPTO.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Jason Cooper <jason@lakedaemon.net>

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
