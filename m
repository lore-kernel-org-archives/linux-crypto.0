From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Test AEAD/authenc algorithms from userspace
Date: Tue, 31 May 2016 13:05:33 +0200
Message-ID: <14797179.fHPkmVmG4b@positron.chronox.de>
References: <CAFXBA=kStufh3TDe=+qQYmd2tNCj9hgXLUKBeoZHBs2VxRBRbQ@mail.gmail.com> <3164476.NJZyJLbx96@tauon.atsec.com> <CAFXBA==PsTepbhPeBMsb1YyKx12B8ie5KC7VF=8pwCSBFJgfgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35200 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbcEaLFh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 07:05:37 -0400
In-Reply-To: <CAFXBA==PsTepbhPeBMsb1YyKx12B8ie5KC7VF=8pwCSBFJgfgg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 31. Mai 2016, 16:28:14 schrieb Harsh Jain:

Hi Harsh,

> Hi Stephen,
> 
> Yes ,It's for Hash. The available API in library for hash update
> "_kcapi_md_update" uses "MSG_MORE" flag always set. It will not
> trigger driver's digest/finup implementation. We need something like
> that
> 
>  _kcapi_common_accept()
> send(handle->opfd, buffer, len, 0); ==> flag = 0.
> 
> It will execute digest callback of selected tfm from User
> Space.(init->digest) Similarly
> 
> _kcapi_common_accept()
> send(handle->opfd, buffer, len, MSG_MORE);
> send(handle->opfd, buffer, len, 0);
> 
> It will execute finup callback of selected tfm. (init->update->finup).
> 
> In that way we can test all callbacks from userspace. In future if you
> feel this use case important. You can add API's to implement this.

Ok, I see that the finup code path is not exercised in the kernel by my 
library.

Why do you think that this code path should be tested by my test code?

The test code shall verify that libkcapi works fine.

Ciao
Stephan
