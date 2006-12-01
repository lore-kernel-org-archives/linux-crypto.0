From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] Pseudo-random number generator
Date: Fri, 1 Dec 2006 15:37:06 +0000
Message-ID: <20061201153706.321926f5@localhost.localdomain>
References: <1164979155.5882.23.camel@bender>
	<20061201133924.023289c4@localhost.localdomain>
	<1164986446.5882.36.camel@bender>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36587 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP id S967359AbWLAPbn
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Dec 2006 10:31:43 -0500
To: Jan Glauber <jan.glauber@de.ibm.com>
In-Reply-To: <1164986446.5882.36.camel@bender>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 01 Dec 2006 16:20:46 +0100
Jan Glauber <jan.glauber@de.ibm.com> wrote:
> Yes, a user can just symlink urandom to prandom and will have a faster
> generator.


More usefully they can use it as an entropy source with an entropy
daemon to feed it into the standard urandom/random.
