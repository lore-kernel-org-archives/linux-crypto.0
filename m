From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: ecc : Wipe memory for p on errors.
Date: Sun, 23 Apr 2017 21:14:18 +0200
Message-ID: <1812636.Q25d83Qtbu@positron.chronox.de>
References: <20170422113134.hzulmuvnveqg7sjq@hackers.mu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Loganaden Velvindron <logan@hackers.mu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59174 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163063AbdDWTOW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2017 15:14:22 -0400
In-Reply-To: <20170422113134.hzulmuvnveqg7sjq@hackers.mu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 22. April 2017, 13:31:34 CEST schrieb Loganaden Velvindron:

Hi Loganaden,

> -	kfree(p);
> +	kzfree(p);

Why do you think this is necessary? p is not filled in this function as this 
function only allocates the memory.

Ciao
Stephan
