From: sri sowj <srisowj4linux@gmail.com>
Subject: fallback mechanism in HASH drivers implimentetion
Date: Sat, 14 Feb 2015 08:27:40 +0530
Message-ID: <CAHTT9V+akq7Rw2BXeiQFLsQpgj2p2OxbNE1uxg2hG2WP9f3YOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:37834 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbbBNC5l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Feb 2015 21:57:41 -0500
Received: by mail-ob0-f195.google.com with SMTP id va2so5871121obc.2
        for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2015 18:57:40 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi ,

I am trying to understand the SHA1 (asynchronous) driver , I am not
really sure regarding below mentioned scenarios,please can some help
me with this?

#1: When driver needs to use fallback mechanism and how does it work?

#2: when do driver needs to use methods like import/export ?

BR,
Srisowj
