From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-crypt: disable block encryption with arc4
Date: Tue, 26 Jan 2010 12:59:15 +0000
Message-ID: <20100126125914.GE5478@agk-dp.fab.redhat.com>
References: <Pine.LNX.4.64.1001251324310.18309@hs20-bc2-1.build.redhat.com> <4B5DE54F.7050206@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com,
	linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753020Ab0AZM7V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2010 07:59:21 -0500
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0QCxKDu015557
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Tue, 26 Jan 2010 07:59:20 -0500
Content-Disposition: inline
In-Reply-To: <4B5DE54F.7050206@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 25, 2010 at 07:39:11PM +0100, Milan Broz wrote:
> This should be solved inside cryptoAPI and not blacklist it in dm-crypt,
> see that thread

Agreed.  I'm not going to apply a dm patch that maintains a hard-coded "broken"
list.

Alasdair

