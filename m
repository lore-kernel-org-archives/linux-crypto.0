From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Problem using dm-crypt with geode LX800 AES-Engine
Date: Wed, 29 Aug 2007 16:15:49 +0200
Message-ID: <20070829141549.GD24782@Chamillionaire.breakpoint.cc>
References: <46D579AB.5040304@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Markus Huehnerbein <silencer@gmx.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:35416 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751427AbXH2OPu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 10:15:50 -0400
Content-Disposition: inline
In-Reply-To: <46D579AB.5040304@gmx.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Markus Huehnerbein | 2007-08-29 15:50:35 [+0200]:

>I 've an embedded board with AMD Geode??? LX 800 Chip. I'm running Debian
>Etch and Kernel 2.6.22.5. What I tried is to use dm-crypt /
>cryptsetup-luks 1.0.5 with the Geode AES-Engine.
>
>The Kernel Modul "geode_aes" is compiled and loaded successfully. The
>problem is, that if the module is loaded and I try:
>	cryptsetup -c aes -s 256 -h sha256 luksFormat /dev/hda2

from a quick look into the source it should work with '-s 128' or
without the -s parameter. Can you confirm this?

Sebastian
