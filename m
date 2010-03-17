From: Emanuele Cesena <emanuele.cesena@gmail.com>
Subject: Re: cryptodev support
Date: Wed, 17 Mar 2010 14:08:40 +0100
Message-ID: <1268831320.2901.21.camel@ec>
References: <4BA0CFFD.7080705@gnutls.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:52073 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab0CQNKT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Mar 2010 09:10:19 -0400
Received: by fxm19 with SMTP id 19so1026681fxm.21
        for <linux-crypto@vger.kernel.org>; Wed, 17 Mar 2010 06:10:17 -0700 (PDT)
In-Reply-To: <4BA0CFFD.7080705@gnutls.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2010-03-17 at 13:50 +0100, Nikos Mavrogiannopoulos wrote:
> Hello,
>  I needed to access crypto hardware modules from userspace and I made
> that by adding cryptodev support on top of linux-crypto. It is a
> separate module available at:
> http://repo.or.cz/w/cryptodev-linux.git
> 
I'm also interested in the userspace module (we are working on a patch
for opencryptoki), but this version looks quite different from the ideas
"recently" discussed in this mailing list and, probably even more
important, from the idea for future development (i.e. moving to a
socket-like interface).

Couldn't be useful to start discussing (read: receive directives) and
officially introduce cryptodev in linux-crypto, instead of losing so
many energies?

Best,
-- 
Emanuele Cesena <emanuele.cesena@gmail.com>

Il corpo non ha ideali

