Return-Path: <SRS0=hYBA=PX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbfAOIMM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Jan 2019 03:12:12 -0500
Date: Tue, 15 Jan 2019 09:12:09 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.4,3.18] crypto: cts - fix crash on short inputs
Message-ID: <20190115081209.GA29858@kroah.com>
References: <20190114232145.205845-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190114232145.205845-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 14, 2019 at 03:21:45PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Hi Greg, please consider applying this to 4.4-stable and 3.18-stable.
> It's a minimal fix for a bug that was fixed incidentally by a large
> refactoring in v4.8.

Now queued up, thanks.

greg k-h
