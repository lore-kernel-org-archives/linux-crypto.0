From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: Re: [PATCH 2/3] SCRIPTS: s/should/must/ for all ERRORs
Date: Wed, 10 Feb 2010 18:59:11 +0100
Message-ID: <2d460de71002100959j49c25e37n11a8870454251d84@mail.gmail.com>
References: <1265762465-21114-1-git-send-email-richih.mailinglist@gmail.com>
	 <20100210084908.ad315b9b.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Walker <dwalker@fifo99.com>,
	linux-kernel@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:39608 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab0BJR7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Feb 2010 12:59:13 -0500
In-Reply-To: <20100210084908.ad315b9b.rdunlap@xenotime.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 10, 2010 at 17:49, Randy Dunlap <rdunlap@xenotime.net> wrot=
e:

> Well, I will gladly disagree. =C2=A0checkpatch is an advisory tool.
> It has no such final authority to enforce /must/.
>
> /must/ would OK on syntax errors that must be fixed before they will =
compile.

fwiw, Joe Perches raised the same point in private conversation so ther=
e
are two votes against this patch.

I submitted it knowing that it might be controversial, but I went with
the rest of the wording in checkpatch. Other errors have similar
wording, for example prohibited, but that does not mean I am hell-bent
on arguing this point.

Personally, I feel that warnings are suggestions and errors are hard
limits, but it is, of course, OK to disagree with this stance. This is
part of the reason why I submitted it as three separate patches instead
of a single one.

This decision is not mine to make in any case. Dropping it is totally
fine by me.


Thanks for your feedback,
Richard


PS: As I am new to the whole concept of touching the large scary kernel
let me use this opportunity to ask if I should expect answers on the
other patch emails or if they are just merged zsh-style: Silently and
you will notice what went through when you pull a few days later.
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
