Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:2203 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbeKITqh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:46:37 -0500
Received: from [10.193.189.121] (harsh.asicdesigners.com [10.193.189.121])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id wA9A6iPQ003281
        for <linux-crypto@vger.kernel.org>; Fri, 9 Nov 2018 02:06:45 -0800
Subject: How driver can mark the algo implementation Unavailable
References: <219de7fd-d6c8-a33a-e946-4a5ee28b63dc@chelsio.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
From: Harsh Jain <harsh@chelsio.com>
Message-ID: <a41e899e-67a9-c398-0ed4-1707851a4eb9@chelsio.com>
Date: Fri, 9 Nov 2018 15:36:43 +0530
MIME-Version: 1.0
In-Reply-To: <219de7fd-d6c8-a33a-e946-4a5ee28b63dc@chelsio.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi All,

PCI based devices can be shutdown from sysfs interface

echo "unbind" > /sys/bus/pci/drivers/cxgb4/unbind

In case device has active Transformation(tfm), Drivers cannot un-register the Algorithms because alg->cra_refcnt will be non zero.

Can driver use the "CRYPTO_ALG_DEAD" flag to mark it un-available so that crypto_alg_lookup does not allocate new tfm using dead algo.

Regards

Harsh Jain
