From: Emanuele Cesena <emanuele.cesena@gmail.com>
Subject: Status of shash
Date: Tue, 29 Dec 2009 18:00:17 +0100
Message-ID: <1262106017.2726.27.camel@ec>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64705 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZL2RB3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Dec 2009 12:01:29 -0500
Received: by fxm25 with SMTP id 25so5388476fxm.21
        for <linux-crypto@vger.kernel.org>; Tue, 29 Dec 2009 09:01:27 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi all,

I'd like to better understand the future plans for shash.

Currently I can see that (please correct me if I'm wrong):
- all the hash algorithms are migrated to shash
- most of the kernel code uses the ahash API
- still some pieces are using the hash API (e.g. IMA)

I want to build a module on top of hash tfm API. 
What should I use? I guess ahash.

In fact I don't need async, while I'd like export/import functions.
So, can I already use shash? 
What about the (near) future? Is it better (for sync) to use hash, or to
wait for shash [*], or to use ahash in any case?


BTW, should IMA be converted to ahash?
This could be a good exercise to start...

Best,

[*] I made some preliminary tests and shash gave me some problems.
Further, looking at the code, it seems it is not yet completely
implemented w.r.t. the tfm API.
-- 
Emanuele Cesena <emanuele.cesena@gmail.com>

Il corpo non ha ideali

