From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Why null skcipher to copy AAD data?
Date: Mon, 4 Jul 2016 17:50:12 +0530
Message-ID: <CAFXBA==GZRefGrLxjYtNbViPEyasdvbbHwJ4hS+swtVfSR=HQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34477 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613AbcGDMUO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Jul 2016 08:20:14 -0400
Received: by mail-oi0-f43.google.com with SMTP id s66so192201933oif.1
        for <linux-crypto@vger.kernel.org>; Mon, 04 Jul 2016 05:20:13 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Why we need null skcipher to copy AAD from src to dst buffer. We can
do the same with some function,who can copy data from src sg list to
dst sg list.

Regards
Harsh Jain
