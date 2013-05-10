From: "Christoph G. Baumann" <cb@sgoc.de>
Subject: Re: [RFC] Freescale DCP crypto acceleration
Date: Fri, 10 May 2013 08:27:48 +0200 (CEST)
Message-ID: <301118167.423842.1368167268167.open-xchange@email.1und1.de>
References: <1368038473-6979-1-git-send-email-tobias.rauter@gmail.com>
Reply-To: "Christoph G. Baumann" <cb@sgoc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Tobias Rauter <tobias.rauter@smaxtec.com>,
	Tobias Rauter <tobiasrauter@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:49992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab3EJG1u (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 May 2013 02:27:50 -0400
In-Reply-To: <1368038473-6979-1-git-send-email-tobias.rauter@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Tobias,

good to see that someone else is also working on this. As I don't have the time
to do a complete rewrite it's all yours :-)
Two remarks:
1. don't forget the SHA hashes
2. try to keep it compatible with the "old" IOCTL interface as tools like
kobs-ng rely on it

Regards
Christoph
