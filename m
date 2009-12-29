From: Richard Zidlicky <rz@linux-m68k.org>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Tue, 29 Dec 2009 18:37:18 +0100
Message-ID: <20091229173718.GA10432@linux-m68k.org>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-2-git-send-email-max@hinterhof.net> <4B390907.8010609@redhat.com> <20091229092158.GA10017@linux-m68k.org> <4B39EA32.8010707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Max Vozeler <max@hinterhof.net>, linux-crypto@vger.kernel.org,
	linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49902 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZL2Rg5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Dec 2009 12:36:57 -0500
Received: by ewy19 with SMTP id 19so2927012ewy.21
        for <linux-crypto@vger.kernel.org>; Tue, 29 Dec 2009 09:36:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4B39EA32.8010707@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

many thanks for the clarifications. Fedora has a very nice and unobstrusive crypto 
setup but finding out the technical details involves looking into quite a few places.
The http://code.google.com/p/cryptsetup/ pages seems to have plenty of information
for a start.

>  (If you think about coldboot or something similar - dm-crypt provides functions to
>  temporarily freeze device and empty keys and I also added support for this to cryptsetup.
>  So the controlled suspend/resume to RAM can ask for LUKS passphrase and unlock master key,
>  preventing active encryption keys in RAM.

that is a really godd idea - is there a howto somewhere? Coldboot is not my main worry
but it is certainly good to take reasonable precautions.

> If you know about some problem in dm-crypt, just let me know (or write to dm-crypt mailing list).

I have some problems with hibernation which look like it might be related to the dm layer
but am not totally sure. Unfortunately it is rare enough that I could not catch it with
any of the remote debugging methods. I could only email a picture of a stack trace.

Richard
