From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: ahash vs. shash
Date: Wed, 7 May 2014 09:35:52 +0300
Message-ID: <CACE9dm-6kTZ91Ha8sMS=Zviqg-Dx6tzeTRVJtsGHKxwwP+TRzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51299 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaEGGfy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 May 2014 02:35:54 -0400
Received: by mail-wi0-f175.google.com with SMTP id f8so4731036wiw.8
        for <linux-crypto@vger.kernel.org>; Tue, 06 May 2014 23:35:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

ahash allows to use HW acceleration, but usually it comes at a cost of
additional HW related configuration overhead, such as configuring hash
module, DMA, etc. For that reason hashing small chucks of data is
faster doing it with shash (CPU) rather than HW acceleration.

I measured long time ago on omap-sham driver but cannot recall any data.

Does anyone have any experience under what data size it is still
better to use shash?


Thanks,

Dmitry
