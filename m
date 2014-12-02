From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: qat - Intel(R) QAT transport code
Date: Tue, 02 Dec 2014 08:49:09 -0800
Message-ID: <547DED85.7080507@intel.com>
References: <20141202122140.GA15748@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
	=?windows-1252?Q?J=F6rn_Engel?= <joern@logfs.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbaLBQwH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 11:52:07 -0500
In-Reply-To: <20141202122140.GA15748@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/02/2014 04:21 AM, Dan Carpenter wrote:
> drivers/crypto/qat/qat_common/adf_transport.c
>    407          /* Enable IRQ coalescing always. This will allow to use
>    408           * the optimised flag and coalesc register.
>    409           * If it is disabled in the config file just use min time value */
>    410          if (adf_get_cfg_int(accel_dev, "Accelerator0",
>    411                              ADF_ETRMGR_COALESCING_ENABLED_FORMAT,
>    412                              bank_num, &coalesc_enabled) && coalesc_enabled)
>                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This condition is reversed, so it only enables coalescing on error.

Hello Dan,
Yes, you are correct. Looks like we never enable interrupt coalescing.
Thanks for reporting the issue. Patch fixing this will be out soon.
Regards,
Tadeusz
