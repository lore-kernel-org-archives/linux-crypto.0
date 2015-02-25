From: sri sowj <srisowj4linux@gmail.com>
Subject: multiple simultaneous crypto sessions from a crypto driver
Date: Wed, 25 Feb 2015 09:33:33 +0530
Message-ID: <CAHTT9VLOg6n+rpMCZLU4b2K_sTBT0NcAGsT2s3UPxCeaPyzqMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35856 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbbBYEDd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Feb 2015 23:03:33 -0500
Received: by pdjp10 with SMTP id p10so1875037pdj.3
        for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2015 20:03:33 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi ,


I am working on understanding crypt drivers in implemented in
asynchronous mode.I am little ambiguous regarding following
scenario,Please
can some help me with this.


#1: If two or more applications will send their requests (may be
different seesions)  to crypto Hardware (may be scheduler ll decide
which App should be allowed).
In this scenario How Crypto Driver will maintain the Hashed
data(Intermediate Hash) for future use i.e., when an application
resumes back?
Is it some thing needs to be handled from the crypto drivers or Linux
Kernel crypto subsystem will take care?

Note:This kind of scenarios even can be observed in IPSEC
implementation Kernel like different requests for
encryption/decryption to a crypto algorithm  from different sessions.

#2: I referred link
"http://www.mail-archive.com/linux-crypto%40vger.kernel.org/msg08177.html"

What I understood is that single "tfm" should be able to serve the
multiple/different requests at a time and intermediate hash per
request has to be
saved in the request context.Please can you let me know how is it
possible in real-time ,please can some one help me with this kind of
requirement in real-time?

BR,
Srisowj
