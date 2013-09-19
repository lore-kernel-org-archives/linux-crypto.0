From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH v2] crypto: caam - map src buffer before access
Date: Thu, 19 Sep 2013 15:39:06 +0300
Message-ID: <523AF06A.4010709@freescale.com>
References: <1378927446-21209-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Yashpal Dutta <yashpal.dutta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:27267
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab3ISMjY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Sep 2013 08:39:24 -0400
Received: from mail73-va3 (localhost [127.0.0.1])	by mail73-va3-R.bigfish.com
 (Postfix) with ESMTP id 01E20160098	for <linux-crypto@vger.kernel.org>; Thu,
 19 Sep 2013 12:39:24 +0000 (UTC)
Received: from VA3EHSMHS038.bigfish.com (unknown [10.7.14.241])	by
 mail73-va3.bigfish.com (Postfix) with ESMTP id 65C9D1A004A	for
 <linux-crypto@vger.kernel.org>; Thu, 19 Sep 2013 12:39:22 +0000 (UTC)
In-Reply-To: <1378927446-21209-1-git-send-email-yashpal.dutta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 9/11/2013 10:24 PM, Yashpal Dutta wrote:
> KMap the buffers before copying trailing bytes during hmac into a session
> temporary buffer. This is required if pinned buffer from user-space is send
> during hmac and is safe even if hmac request is generated from within kernel.
>
> Signed-off-by: Yashpal Dutta <yashpal.dutta@freescale.com>
Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

Why haven't you Cc-ed stable?
