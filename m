From: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Tue, 29 Dec 2009 10:21:58 +0100
Message-ID: <20091229092158.GA10017@linux-m68k.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-2-git-send-email-max@hinterhof.net> <4B390907.8010609@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Max Vozeler <max@hinterhof.net>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:39621 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZL2JV7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Dec 2009 04:21:59 -0500
Received: by ewy19 with SMTP id 19so2527334ewy.21
        for <linux-crypto@vger.kernel.org>; Tue, 29 Dec 2009 01:21:58 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B390907.8010609@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 28, 2009 at 08:37:43PM +0100, Milan Broz wrote:

Hi,

> 
> But please can you add more explanation into documentation about this mode?
> Is there any paper which analyses that mode - if so can you add link
> to description?
> (and yes, I know loop-AES documentation:-)

I have some archived mail messages from Jari explaining the details of the encryption 
pretty exhaustively if that helps.

While we are at it - are you aware of any documentation of the "mainline" dm-crypt
implementation? I have not seen anything, much less any explanation if it has improved 
any since the ancient watermarking attack.

http://luks.endorphin.org/ is down, http://www.saout.de/misc/dm-crypt/ has plenty of
information but I am not sure if it is up to date.. well if it is than it seems default
dm-crypt still has more or less snake oil quality encryption.

Richard
