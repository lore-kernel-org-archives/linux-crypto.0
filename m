From: Leo Samulis <anagon@gmail.com>
Subject: DM-Steg: New steganographic encryption module
Date: Wed, 30 Nov 2011 16:27:14 +0000
Message-ID: <CAO=0D2BDW9zuSWueEQUjffh-jSA5_JCqmf67keLKqw-+89dNXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36524 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344Ab1K3Q1P (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Nov 2011 11:27:15 -0500
Received: by vcbfk14 with SMTP id fk14so536636vcb.19
        for <linux-crypto@vger.kernel.org>; Wed, 30 Nov 2011 08:27:14 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello folks,

I'd like to introduce DM-Steg. It's a device mapper module that
provides deniable/steganographic encryption. DM-Steg provides similar
capabilities to Rubberhose (a now defunct project by Julian Assange et
al.) and more advanced deniable encryption than Truecrypt.

DM-Steg can be used to hide any number of strongly encrypted volumes
inside block devices or files. There is no way to determine how many
volumes a block device contains or even if the block device is not
random data. DM-Steg uses strong encryption yet still achives goood
performance - up to 148 MB/s on my core 2 duo, and only 1% slowdown on
kernel compiles.

DM-Steg is working code and free software, so if you have any interest
in deniable encryption, please head over to http://dmsteg.sf.net and
grab the tarball!

I've taken this project as far as I want so I'd very much like it if
there's anyone in the OSS community who wants to take it further.
Don't be shy! :)

All the best,

- Leo
