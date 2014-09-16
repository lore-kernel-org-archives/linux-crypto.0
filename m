From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: RFC possible changes for Linux random device
Date: Tue, 16 Sep 2014 20:03:41 +0200
Message-ID: <1410890621.3666.0.camel@nomad.lan>
References: <CACXcFmnWUOBO-_MhMKUEY1xB1Tk4fSUrvfkmwCQicJSELqa8XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58144 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbaIPSDo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Sep 2014 14:03:44 -0400
Received: by mail-wi0-f171.google.com with SMTP id bs8so6854347wib.4
        for <linux-crypto@vger.kernel.org>; Tue, 16 Sep 2014 11:03:43 -0700 (PDT)
In-Reply-To: <CACXcFmnWUOBO-_MhMKUEY1xB1Tk4fSUrvfkmwCQicJSELqa8XA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2014-09-15 at 20:40 -0400, Sandy Harris wrote:

> I have some experimental code to replace parts of random.c It is not
> finished but far enough along to seek comment. It does compile with
> either gcc or clang, run and produce reasonable-looking results but is
> not well-tested. splint(1) complains about parts of it, but do not
> think it is indicating any real problems.
> 
> I change nothing on the input side; the entropy collection and
> estimation parts of existing code are untouched. The hashing and
> output routines, though, are completely replaced, and much of the
> initialisation code is modified.
> It uses the 128-bit hash from AES-GCM instead of 160-bit SHA-1.
> Changing the hash allows other changes. One design goal was improved
> decoupling so that heavy use of /dev/urandom does not deplete the
> entropy pool for /dev/random. Another was simpler mixing in of
> additional data in various places.

Hello,
 What are the advantages of this change? It was not clear from the
original thread.

regards,
Nikos
