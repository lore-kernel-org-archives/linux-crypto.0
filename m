From: sri sowj <srisowj4linux@gmail.com>
Subject: How to test Export and Imports methods in a crypto driver
Date: Mon, 23 Feb 2015 22:51:59 +0530
Message-ID: <CAHTT9V+fBf5yR6em7UEar4P-TbfzGF_YRoz8TNdokkNfjBzgAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37777 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbbBWRWA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2015 12:22:00 -0500
Received: by pabrd3 with SMTP id rd3so29025731pab.4
        for <linux-crypto@vger.kernel.org>; Mon, 23 Feb 2015 09:21:59 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

I am trying to analyze linux kernel crypto drivers  . I have noticed
methods like export/import to save and retrieve intermediate Hash
data.

Please can some one point me to a use case in Real-Time,so that I can
test these interfaces functionality ?

BR,
& Srisowj
