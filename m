Return-Path: <SRS0=fnEV=PW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mout.web.de ([212.227.15.14]:58897 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfANHke (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jan 2019 02:40:34 -0500
To: kernel-janitors@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Generating identifiers similar to UUIDs but without dashes
Message-ID: <c7463786-82f1-01c8-7f47-e784f2602209@web.de>
Date: Mon, 14 Jan 2019 08:40:17 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

The file “/proc/sys/kernel/random/uuid” provides a bit of useful data.
The formal definition of the string representation for universally unique
identifiers requires the use of four dashes for the concatenation of fields.
https://tools.ietf.org/html/rfc4122#page-4
https://stackoverflow.com/questions/24481801/is-uuid-without-dashes-hyphens-valid#answer-24484051

Now I am looking again for possibilities to generate reasonably unique
identifiers also without these dashes.
Can any data processing benefit from the avoidance of such extra characters?

Regards,
Markus
