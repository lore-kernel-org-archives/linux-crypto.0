From: Emanuele Cesena <emanuele.cesena@gmail.com>
Subject: Re: Userspace API /dev/crypto
Date: Wed, 13 Jan 2010 09:16:08 +0100
Message-ID: <1263370568.2981.16.camel@ec>
References: <63386a3d1001121237s3e7c4b19g82ead5dc9dc7f63c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Linus Walleij <linus.ml.walleij@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:59287 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab0AMIRW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2010 03:17:22 -0500
Received: by ewy1 with SMTP id 1so149148ewy.28
        for <linux-crypto@vger.kernel.org>; Wed, 13 Jan 2010 00:17:20 -0800 (PST)
In-Reply-To: <63386a3d1001121237s3e7c4b19g82ead5dc9dc7f63c@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2010-01-12 at 21:37 +0100, Linus Walleij wrote:
> Has there been some/any progress on the userspace API since, or
> is this up for grabs?
> 
As far as I know the most recent advance is:
"Add CryptoAPI User Interface Support v8"
http://marc.info/?t=122696476500001&r=1&w=2

I recommend you to read the whole thread, since in the end it appears
that new versions may move to a socket-oriented interface.

Finally, for OpenSSL, we are working on a pkcs11 engine so that there
will be no need to apply patches (and further we expect it could be used
with other apps too, like firefox). We hope to submit it soon.

Best regards,
-- 
Emanuele Cesena <emanuele.cesena@gmail.com>

Il corpo non ha ideali

