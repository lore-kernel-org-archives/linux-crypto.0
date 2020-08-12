Return-Path: <SRS0=h4Ng=BW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE0B8C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 00:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81F412080C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Aug 2020 00:34:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgHLAep (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:34:45 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51256 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbgHLAeo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Aug 2020 20:34:44 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k5eig-0007Va-Me; Wed, 12 Aug 2020 10:34:19 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 12 Aug 2020 10:34:18 +1000
Date:   Wed, 12 Aug 2020 10:34:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     richard.gong@linux.intel.com
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        dinguyen@kernel.org, richard.gong@intel.com
Subject: Re: [PATCHv1 2/2] crypto: add Intel SoCFPGA crypto service driver
Message-ID: <20200812003418.GA4166@gondor.apana.org.au>
References: <1597154182-26970-1-git-send-email-richard.gong@linux.intel.com>
 <1597154182-26970-3-git-send-email-richard.gong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1597154182-26970-3-git-send-email-richard.gong@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 11, 2020 at 08:56:22AM -0500, richard.gong@linux.intel.com wrote:
> From: Richard Gong <richard.gong@intel.com>
> 
> Add Intel FPGA crypto service (FCS) driver to support new crypto services
> on Intel SoCFPGA platforms.
> 
> The crypto services include security certificate, image boot validation,
> security key cancellation, get provision data, random number generation,
> advance encrtption standard (AES) encryption and decryption services.
> 
> To perform supporting crypto features on Intel SoCFPGA platforms, Linux
> user-space application interacts with FPGA crypto service (FCS) driver via
> structures defined in include/uapi/linux/intel_fcs-ioctl.h.
> 
> The application allocates spaces for IOCTL structure to hold the contents
> or points to the data that FCS driver needs, uses IOCTL calls to passes
> data to kernel FCS driver for processing at low level firmware and get
> processed data or status back form the low level firmware via FCS driver.
> 
> The user-space application named as fcs_client is at
> https://github.com/altera-opensource/fcs_apps/tree/fcs_client.
> 
> Signed-off-by: Richard Gong <richard.gong@intel.com>

Nack.  This driver has nothing to do with the Crypto API.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
