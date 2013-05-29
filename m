From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH v3] OMAP: AES: Don't idle/start AES device between Encrypt
 operations
Date: Wed, 29 May 2013 15:05:11 -0400
Message-ID: <51A65167.70303@ti.com>
References: <1369853986-3970-1-git-send-email-joelagnel@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linux-omap@vger.kernel.org>,
	"Mark A. Greer" <mgreer@animalcreek.com>,
	Kevin Hilman <khilman@linaro.org>
To: Joel A Fernandes <joelagnel@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:52746 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3E2TFY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 May 2013 15:05:24 -0400
In-Reply-To: <1369853986-3970-1-git-send-email-joelagnel@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wednesday 29 May 2013 02:59 PM, Joel A Fernandes wrote:
> Calling runtime PM API for every block causes serious perf hit to
> crypto operations that are done on a long buffer.
> As crypto is performed on a page boundary, encrypting large buffers can
> cause a series of crypto operations divided by page. The runtime PM API
> is also called those many times.
> 
> We call runtime_pm_get_sync only at beginning on the session (cra_init)
> and runtime_pm_put at the end. This result in upto a 50% speedup as below.
> This doesn't make the driver to keep the system awake as runtime get/put
> is only called during a crypto session which completes usually quickly.
> 
Nice !!

> Before:
> root@beagleboard:~# time -v openssl speed -evp aes-128-cbc
> Doing aes-128-cbc for 3s on 16 size blocks: 13310 aes-128-cbc's in 0.01s
> Doing aes-128-cbc for 3s on 64 size blocks: 13040 aes-128-cbc's in 0.04s
> Doing aes-128-cbc for 3s on 256 size blocks: 9134 aes-128-cbc's in 0.03s
> Doing aes-128-cbc for 3s on 1024 size blocks: 8939 aes-128-cbc's in 0.01s
> Doing aes-128-cbc for 3s on 8192 size blocks: 4299 aes-128-cbc's in 0.00s
> 
> After:
> root@beagleboard:~# time -v openssl speed -evp aes-128-cbc
> Doing aes-128-cbc for 3s on 16 size blocks: 18911 aes-128-cbc's in 0.02s
> Doing aes-128-cbc for 3s on 64 size blocks: 18878 aes-128-cbc's in 0.02s
> Doing aes-128-cbc for 3s on 256 size blocks: 11878 aes-128-cbc's in 0.10s
> Doing aes-128-cbc for 3s on 1024 size blocks: 11538 aes-128-cbc's in 0.05s
> Doing aes-128-cbc for 3s on 8192 size blocks: 4857 aes-128-cbc's in 0.03s
> 
> While at it, also drop enter and exit pr_debugs, in related code. tracers
> can be used for that.
> 
> Tested on a Beaglebone (AM335x SoC) board.
> 
> v2 changes:
> Refreshed patch on kernel v3.10-rc3
> v3 changes:
> Included Acks in commit message
> 
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
> Acked-by: Kevin Hilman <khilman@linaro.org>
> Acked-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
