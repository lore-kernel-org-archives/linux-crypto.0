From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH v3 11/22] staging: ccree: fix line indentation and breaks
Date: Mon, 14 Aug 2017 23:44:21 -0700
Message-ID: <1502779461.8295.32.camel@perches.com>
References: <1502778412-16255-1-git-send-email-gilad@benyossef.com>
         <1502778412-16255-12-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502778412-16255-12-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, 2017-08-15 at 09:26 +0300, Gilad Ben-Yossef wrote:
> Fix wrong indentation and line breaks, including missing tabs,
> breaking lines longer then 80 char or wrongly broken.
[]
> diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
[]
> -			SSI_LOG_ERR("snprintf returned %d . aborting buffer array dump\n", ret);
> +			SSI_LOG_ERR
> +			    ("snprintf returned %d . aborting buffer array dump\n",
> +			     ret);

This change is quite unpleasant to read.
