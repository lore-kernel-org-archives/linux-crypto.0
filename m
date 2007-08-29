From: Markus Huehnerbein <silencer@gmx.ch>
Subject: Problem using dm-crypt with geode LX800 AES-Engine
Date: Wed, 29 Aug 2007 15:50:35 +0200
Message-ID: <46D579AB.5040304@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55648 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755932AbXH2Nuj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 09:50:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello list,

I 've an embedded board with AMD Geode=E2=84=A2 LX 800 Chip. I'm runnin=
g Debian
Etch and Kernel 2.6.22.5. What I tried is to use dm-crypt /
cryptsetup-luks 1.0.5 with the Geode AES-Engine.

The Kernel Modul "geode_aes" is compiled and loaded successfully. The
problem is, that if the module is loaded and I try:
	cryptsetup -c aes -s 256 -h sha256 luksFormat /dev/hda2
after supplying the password I get the following error:

=46ailed to setup dm-crypt key mapping.
Check kernel for support for the aes-cbc-plain cipher spec and verify
that /dev/hda2 contains at least 258 sectors.
=46ailed to write to key storage.
Command failed.

If I remove the module (rmmod geode-aes) the cryptsetup works fine.
Any suggestions are very welcome.

Kind regards,
Markus
