From: Kim Phillips <kim.phillips@linaro.org>
Subject: Re: [PATCH v4] crypto: caam - map src buffer before access
Date: Mon, 23 Sep 2013 13:51:34 -0500
Message-ID: <20130923135134.23a7462d143b8e2a1f0cc165@linaro.org>
References: <1379753795-14949-1-git-send-email-yashpal.dutta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: yashpal.dutta@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:63033 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab3IWSvg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 14:51:36 -0400
Received: by mail-oa0-f48.google.com with SMTP id m6so959038oag.7
        for <linux-crypto@vger.kernel.org>; Mon, 23 Sep 2013 11:51:36 -0700 (PDT)
In-Reply-To: <1379753795-14949-1-git-send-email-yashpal.dutta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 21 Sep 2013 14:26:35 +0530
Yashpal Dutta <yashpal.dutta@freescale.com> wrote:

> KMap the buffers before copying trailing bytes during hmac into a session
> temporary buffer. This is required if pinned buffer from user-space is send
> during hmac and is safe even if hmac request is generated from within kernel.

it may be "safe" but it adversely affects performance for AF_ALG users,
no?

why does ocf-linux need this, and not AF_ALG?  Is a patch to ocf-linux
more appropriate here?

> Cc:stable@vger.kernel.org

fyi, this violates the following rule in
Documentation/stable_kernel_rules.txt:

 - It or an equivalent fix must already exist in Linus' tree (upstream).

Kim
