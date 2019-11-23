Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF4FC432C0
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E87A2070E
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 00:48:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="b9dT9QGu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKWAsw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Nov 2019 19:48:52 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44010 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfKWAsv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Nov 2019 19:48:51 -0500
Received: by mail-lj1-f196.google.com with SMTP id y23so9305523ljh.10
        for <linux-crypto@vger.kernel.org>; Fri, 22 Nov 2019 16:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=CO1PvkNBKC29DHOlapGJKqbdGQIw7CGnLoX3d7miUss=;
        b=b9dT9QGuKRAdsXfYMKphv0AIll/WvgeSmmKC+Bf6Ve9YF4POy2ijzM7FolFQQH28jR
         4BvrmLKml4dTaKl2qonDiVEcEGXkCgo5ET3NsZtKVo47RcDisp5UsN/hlaIS7lvaFYUp
         jbz7YNdzZJDRJWJQ4WWOu7t9zK/wtaNB2aI2buc7Nr18D/q63jWc3Z7mYUO089n4q563
         e4S2RN45QhhQLsuMok34eWMRFAH8kCUAvKXyKrNN6QB8HZHwKmlN9Yd/fYQAOqk/Y/Qc
         nVY1oYp4ojjPT9X/fPUq861WQKuzAGnHsn6b0C3fTo+/wLPOCfR7K9fHGRIXByTOnYHN
         93yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=CO1PvkNBKC29DHOlapGJKqbdGQIw7CGnLoX3d7miUss=;
        b=SmZTI86Ft/pO87m4SB1Mo1F9Uo6Uf1uSlt/Ah6rRERGMptPjObQeIRgqkrg7V7Squi
         vd532ezC6E4Sjaue8vDq/ptBcG9XVqOcyy6hLWeI9M5icgJaNdhffVapab79mDZxzHWf
         lJs8iSsnzhL8miG1D4K2Bivgv+CiU+soO6ZGdwyNMhtWDXPUqP2okBgjZtwhLJ8u78Oq
         9ZYwxqqQN+oKjCt5f4q6xzurXy9V9VRhCYAZr3t4QD2zxjqPEWkXRH6bPC76aIiG2mCP
         TTlnWocRpkd+T/QaORZJkP4d7O0PXP4/Zjunz2YE6gjpuYsDgufT7FODA0JFOrRz8uoD
         +buw==
X-Gm-Message-State: APjAAAUBfILlGCLAll2gU5WDdYIVWPJtpa63xfVwGChHCyDs0e+zyY21
        hV5S4v/uFVh7fv0Y+4sG4CvpIA==
X-Google-Smtp-Source: APXvYqzrhPo6DSbsP2edvEoJaffajmaT8DOabrty6HjlIS7HrmOkDHtSYMhG+4Bp+cvrQ18E9F69DQ==
X-Received: by 2002:a2e:c42:: with SMTP id o2mr113538ljd.222.1574470129738;
        Fri, 22 Nov 2019 16:48:49 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w11sm3786846lfe.56.2019.11.22.16.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:48:49 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:48:42 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        nirranjan@chelsio.com, atul.gupta@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net-next v2 0/3] cxgb4: add UDP Segmentation Offload
 support
Message-ID: <20191122164842.1d040c81@cakuba.netronome.com>
In-Reply-To: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
References: <cover.1574383652.git.rahul.lakkireddy@chelsio.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 22 Nov 2019 06:30:00 +0530, Rahul Lakkireddy wrote:
> This series of patches add UDP Segmentation Offload (USO) supported
> by Chelsio T5/T6 NICs.
> 
> Patch 1 updates the current Scatter Gather List (SGL) DMA unmap logic
> for USO requests.
> 
> Patch 2 adds USO support for NIC and MQPRIO QoS offload Tx path.
> 
> Patch 3 adds missing stats for MQPRIO QoS offload Tx path.
> 
> Thanks,
> Rahul
> 
> v2:
> - Remove inline keyword from write_eo_udp_wr() in sge.c in patch 2.
>   Let the compiler decide.

Okay, these are good enough, so applied to net-next. Thanks!
