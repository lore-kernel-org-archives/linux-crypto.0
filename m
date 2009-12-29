From: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: [PATCH 4/4] crypto: lmk2/lmk3 cipher block modes
Date: Tue, 29 Dec 2009 02:18:21 +0100
Message-ID: <20091229011821.GC1348@linux-m68k.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-5-git-send-email-max@hinterhof.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>
To: Max Vozeler <max@hinterhof.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45275 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbZL2BR7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 20:17:59 -0500
Received: by ewy19 with SMTP id 19so2330046ewy.21
        for <linux-crypto@vger.kernel.org>; Mon, 28 Dec 2009 17:17:57 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1262026755-23056-5-git-send-email-max@hinterhof.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 28, 2009 at 07:59:15PM +0100, Max Vozeler wrote:

> +	help
> +	  LMK block cipher modes (lmk2/lmk3).
> +
> +	  These modes are compatible with Loop-AES. Use them with a 
> +	  dm-crypt cipher string aes-lmk2-plain64-multi:64 (for Loop-AES
> +	  v2.x) or aes-lmk2-plain64-multi:64 (for Loop-AES v3.x).
                       ^^^^
should that be lmk3 ?

Too tired to look further..

Richard
