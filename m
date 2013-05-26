From: Matt <jackdachef@gmail.com>
Subject: Re: Oops on 3.10-rc1 related to ssh256_ssse3
Date: Sun, 26 May 2013 17:11:04 +0200
Message-ID: <CAG-aW04xGTjLf85paG5dMNLT2mOaxqtuR-Fh61Sw-QM-0hgLYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org, Julian Wollrath <jwollrath@web.de>
To: "Jussi Kivilinna >" <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:62721 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab3EZPLF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 26 May 2013 11:11:05 -0400
Received: by mail-qa0-f42.google.com with SMTP id bs12so640834qab.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 May 2013 08:11:04 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>Appears to be stack corruption caused by sha256_transform_ssse3. >Does attached
>patch help?
>
>-Jussi

Hi Jussi, Julian,

Hi Crypto-List,


yes, the attached patch let me boot the kernel and there don't seem to
be any more additional issues or messages so far

Please mark it for inclusion in 3.10-rc3 or at least final 3.10


Thanks & Kind Regards

Matt

(Re-sending in plain text mode due to mailing list rejecting html-mails)
