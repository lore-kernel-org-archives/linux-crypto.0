Return-Path: <SRS0=GLFy=62=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D33C47255
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 02:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9966F2070B
	for <linux-crypto@archiver.kernel.org>; Tue, 12 May 2020 02:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgELCzV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 May 2020 22:55:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39652 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727892AbgELCzV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 May 2020 22:55:21 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id EB667E78D5189A354AC2
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2020 10:55:19 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 12 May 2020
 10:55:14 +0800
To:     <linux-crypto@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Subject: Question: SHASH or AHASH.
Message-ID: <7eedd7ca-18a3-f5de-e477-f4b468cfc7f1@huawei.com>
Date:   Tue, 12 May 2020 10:55:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Sorry for disturbing you.
I got a question: which API should my I/O Crypto device driver use, 
SHASH or AHASH?
For performance, I would like to use AHASH since I/O device doing better 
at asynchronous mode.

Thanks,

Zaibo

.

