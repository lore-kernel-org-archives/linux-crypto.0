From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [RFC PATCH v1 1/1] crypto: algif_compression - User-space
 interface for compression
Date: Sun, 16 Apr 2017 18:31:19 -0700
Message-ID: <20170417013119.GA1910@zzz>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com>
 <1492108494-10694-2-git-send-email-akamaluddin@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        akamaluddin@cavium.com, pathreya@cavium.com, machalla@cavium.com
To: Abed Kamaluddin <abedamu@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33913 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757049AbdDQBbX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Apr 2017 21:31:23 -0400
Received: by mail-pg0-f67.google.com with SMTP id o123so24283885pga.1
        for <linux-crypto@vger.kernel.org>; Sun, 16 Apr 2017 18:31:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1492108494-10694-2-git-send-email-akamaluddin@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 14, 2017 at 12:04:54AM +0530, Abed Kamaluddin wrote:
> crypto: algif_compression - User-space interface for compression
> 
> This patch adds af_alg plugin for compression algorithms of type scomp/acomp
> registered to the kernel crypto layer.
> 
> The user needs to set operation (compression/decompression) as a control
> message to sendmsg, identical to selecting the cipher operation type in case of
> ciphers. Once a sendmsg call occurs, no further writes can be made to the
> socket until all previous data has been processed and read. Therefore the
> interface only supports one request at a time.
> 
> The interface is completely synchronous; all operations are carried out in
> recvmsg and will complete prior to the system call returning.
> 
> The sendmsg and recvmsg interface supports directly reading/writing to 
> user-space without additional copying, i.e., the kernel crypto interface will
> receive the user-space address as its input/output SG list. The scomp interface
> or crypto drivers may copy the data as required.

Fun, so unprivileged users will be able to feed arbitrary data into the kernel's
zlib, LZ4, LZO, etc. compressors and decompressors.  Including zlib which is 12
years out of date from the upstream version.  Moreover, if anyone decides to
optimize these to directly support the new "acomp" (page-based) API, e.g. for
zlib by using its streaming API, then the algorithms will be passed the actual
userspace memory which can be modified by userspace concurrently.  When people
write compression algorithms usually it's assumed that's not possible.  At the
very least, it's unlikely to have been covered by fuzz testing that's been done
on the original userspace versions of these algorithms.  They might be safe by
chance, but I don't know.

Why does userspace need to be able to call the in-kernel zlib, LZ4, LZO, etc.
anyway?  At the very least, how about limiting the new attack surface by only
exposing algorithms provided by hardware drivers?

Eric
