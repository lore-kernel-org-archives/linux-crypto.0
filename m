From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: =?utf-8?B?5Zue5aSN77yaUmU=?=
	=?utf-8?Q?=3A?= vgdisplay problem with hifn795x
Date: Sat, 6 Dec 2008 18:19:14 +0300
Message-ID: <20081206151914.GA31165@ioremap.net>
References: <20081130082600.C00C836FC34@mail3-113.sinamail.sina.com.cn> <20081130101208.GA20720@ioremap.net> <493A87B3.3050209@sina.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: "Lingbo Tang (SINA)" <tanglb@sina.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from cs-studio.ru ([195.178.208.66]:46614 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbYLFPTQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Dec 2008 10:19:16 -0500
Content-Disposition: inline
In-Reply-To: <493A87B3.3050209@sina.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 06, 2008 at 10:09:55PM +0800, Lingbo Tang (SINA) (tanglb@sina.com) wrote:
> In some cases the non-debug version can work with "mkfs.xfs", but it
> could not in most case.
> I tried to disable most services in the system, but it seems have no
> related to the system load.

So I suppose it is easy to reproduce problem. Please show 'dmesg' output
for the hung case when debug is turned off. Did you see register dump
message when that happened? Please also try attached patch and show the
hung dmesg (with tured off heavy debug).

Thank you.

-- 
	Evgeniy Polyakov

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="hifn.err_debug"

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 6e9b39c..fc29bec 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2093,6 +2093,10 @@ static int hifn_handle_req(struct ablkcipher_request *req)
 		spin_unlock_irqrestore(&dev->lock, flags);
 	}
 
+	if (err)
+		printk("%s: nbytes: %u, started: %u, qlen: %d, err: %d.\n",
+			__func__, req->nbytes, dev->started, dev->queue.qlen, err);
+
 	return err;
 }
 

--XsQoSWH+UP9D9v3l--
