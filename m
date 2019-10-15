Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9C4EECE58F
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 03:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A962086A
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 03:15:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ck4GEFQC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbfJODPI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 23:15:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbfJODPI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 23:15:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rGXKOzZI2i2ULcbgzDpG/mG1eu5gxk2EGw7KyGeZWwE=; b=Ck4GEFQCqtrUxKelUCq8Q93OE
        TgZCkXwGyd9+XQ40HYW8ayvgLfti0hqTDa/CvRTsliaSADnE0HCCMC+vmvq9WGGbdffVTCNYxlnCD
        4Mrl5Zi4BKTGxL9fnpjlQMVLdNBXgDcfNCMIw8MKAMk+oWO3/qbzDB4KFlPcaCrDkE59assZz3cd5
        +rjncO71ZMRE4j0IH3/9bteALR9aB3djRUl1V+UH+aLGCY+gcZPHu4bgNrak6aZQGDhqeDmnfIQlA
        lvsZmqvgnm+aKjD3Hejv3+pRbfLWXv1Sydao3hwwLdrvJuNkXSJRQ3Tb12fWsiMj1dY974Z1KiKkp
        WEffcX/fw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKDIe-0000xB-K6; Tue, 15 Oct 2019 03:15:04 +0000
Date:   Mon, 14 Oct 2019 20:15:04 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Tim.Bird@sony.com
Cc:     jani.nikula@linux.intel.com, changbin.du@gmail.com, corbet@lwn.net,
        linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org
Subject: Re: [PATCH] kernel-doc: rename the kernel-doc directive 'functions'
 to 'specific'
Message-ID: <20191015031504.GB32665@bombadil.infradead.org>
References: <20191013055359.23312-1-changbin.du@gmail.com>
 <875zkrd7nq.fsf@intel.com>
 <ECADFF3FD767C149AD96A924E7EA6EAF977CAF09@USCULXMSG01.am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ECADFF3FD767C149AD96A924E7EA6EAF977CAF09@USCULXMSG01.am.sony.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 14, 2019 at 08:48:48PM +0000, Tim.Bird@sony.com wrote:
> 
> 
> > -----Original Message-----
> > From: Jani Nikula on October 13, 2019 11:00 PM
> > On Sun, 13 Oct 2019, Changbin Du <changbin.du@gmail.com> wrote:
> > > The 'functions' directive is not only for functions, but also works for
> > > structs/unions. So the name is misleading. This patch renames it to
> > > 'specific', so now we have export/internal/specific directives to limit
> > > the functions/types to be included in documentation. Meanwhile we
> > improved
> > > the warning message.
> > 
> > Agreed on "functions" being less than perfect. It directly exposes the
> > idiosyncrasies of scripts/kernel-doc. I'm not sure "specific" is any
> > better, though.
> 
> I strongly agree with this.  'specific' IMHO, has no semantic value and
> I'd rather just leave the only-sometimes-wrong 'functions' than convert
> to something that obscures the meaning always.
> 
> > 
> > Perhaps "symbols" would be more self-explanatory. Or, actually make
> > "functions" only work on functions, and add a separate keyword for other
> > stuff. *shrug*
> My preference would be to use 'symbols'.  I tried to come up with something
> but 'symbols' is better than anything I came up with.

structures aren't symbols though ... How about 'identifier'?
