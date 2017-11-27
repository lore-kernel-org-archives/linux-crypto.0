From: James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH] X.509: fix buffer overflow detection in sprint_oid()
Date: Mon, 27 Nov 2017 19:34:40 +1100 (AEDT)
Message-ID: <alpine.LFD.2.20.1711271934270.2808@localhost>
References: <20171127071751.25935-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Takashi Iwai <tiwai@suse.de>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45049 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751277AbdK0Iey (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Nov 2017 03:34:54 -0500
In-Reply-To: <20171127071751.25935-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 26 Nov 2017, Eric Biggers wrote:

> 
> Fixes: 4f73175d0375 ("X.509: Add utility functions to render OIDs as strings")
> Cc: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  lib/oid_registry.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)


Reviewed-by: James Morris <james.l.morris@oracle.com>


-- 
James Morris
<james.l.morris@oracle.com>
