From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: qat - Intel(R) QAT transport code
Date: Tue, 02 Dec 2014 11:01:53 -0800
Message-ID: <547E0CA1.7000008@intel.com>
References: <20141202122140.GA15748@mwanda> <547DED85.7080507@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
	=?windows-1252?Q?J=F6rn_Engel?= <joern@logfs.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:50833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753495AbaLBTNM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 14:13:12 -0500
In-Reply-To: <547DED85.7080507@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/02/2014 08:49 AM, Tadeusz Struk wrote:
> On 12/02/2014 04:21 AM, Dan Carpenter wrote:
>> drivers/crypto/qat/qat_common/adf_transport.c
>>    407          /* Enable IRQ coalescing always. This will allow to use
>>    408           * the optimised flag and coalesc register.
>>    409           * If it is disabled in the config file just use min time value */
>>    410          if (adf_get_cfg_int(accel_dev, "Accelerator0",
>>    411                              ADF_ETRMGR_COALESCING_ENABLED_FORMAT,
>>    412                              bank_num, &coalesc_enabled) && coalesc_enabled)
>>                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> This condition is reversed, so it only enables coalescing on error.
> 
> Hello Dan,
> Yes, you are correct. Looks like we never enable interrupt coalescing.
> Thanks for reporting the issue. Patch fixing this will be out soon.
> Regards,
> Tadeusz
> 
Hi,
I had to take a closer look to see what's going on there.
We do enable coalescing always, just as the comment states (in function
adf_enable_ring_irq(), line 105). The adf_enable_coalesc() function only
reads the coalescing timer from the configuration and stores it in the
bank->irq_coalesc_timer.

Your point is still valid - the condition is reversed so we have always
used ADF_COALESCING_MIN_TIME.
What's also missing is initialization of coalesc_enabled and the
adf_enable_coalesc() function should really be called
adf_get_coalesc_timer()
I'll send a patch to fix it.
Thanks again.
Regards,
Tadeusz
