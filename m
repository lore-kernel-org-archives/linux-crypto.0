Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671F6C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36B5320657
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 19:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730105AbfFXTao (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 15:30:44 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:37207 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729180AbfFXTao (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 15:30:44 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 03618181D3403;
        Mon, 24 Jun 2019 19:30:43 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: leaf43_5d60cb96f485f
X-Filterd-Recvd-Size: 1576
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Mon, 24 Jun 2019 19:30:41 +0000 (UTC)
Message-ID: <23a5979082c89d7028409ad9ae082840411e1ca6.camel@perches.com>
Subject: Re: [PATCH 0/3] Clean up crypto documentation
From:   Joe Perches <joe@perches.com>
To:     "Hook, Gary" <Gary.Hook@amd.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Date:   Mon, 24 Jun 2019 12:30:40 -0700
In-Reply-To: <156140322426.29777.8610751479936722967.stgit@taos>
References: <156140322426.29777.8610751479936722967.stgit@taos>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2019-06-24 at 19:07 +0000, Hook, Gary wrote:
> Tidy up the crypto documentation by filling in some variable
> descriptions, make some grammatical corrections, and enhance
> formatting.

While this seems generally OK, please try not to make the
readability of the source _text_ less intelligible just
to enhance the output formatting of the html.

e.g.:

Unnecessary blank lines separating function descriptions
Removing space alignment from bullet point descriptions

etc..,



