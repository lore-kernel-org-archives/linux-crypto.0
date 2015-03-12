From: Andrew Bresticker <abrestic@chromium.org>
Subject: Re: [PATCH V4 2/2] Documentation: crypto: Add DT binding info for the
 img hw hash accelerator
Date: Thu, 12 Mar 2015 09:32:28 -0700
Message-ID: <CAL1qeaFy0fmuvYtDGswobDYho0o+pMfYRhinRxSNqKLfChZoNg@mail.gmail.com>
References: <1426126012-16061-1-git-send-email-james.hartley@imgtec.com>
	<1426126012-16061-3-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>, smueller@chronox.de,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Ezequiel Garcia <ezequiel.garcia@imgtec.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:45390 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775AbbCLQc3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 12:32:29 -0400
Received: by qcwb13 with SMTP id b13so19882038qcw.12
        for <linux-crypto@vger.kernel.org>; Thu, 12 Mar 2015 09:32:29 -0700 (PDT)
In-Reply-To: <1426126012-16061-3-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

On Wed, Mar 11, 2015 at 7:06 PM, James Hartley <james.hartley@imgtec.com> wrote:
> This adds the binding documentation for the Imagination Technologies hash
> accelerator that provides hardware acceleration for SHA1/SHA224/SHA256/MD5
> hashes.  This hardware will be present in the upcoming pistachio SoC.
>
> Signed-off-by: James Hartley <james.hartley@imgtec.com>

Reviewed-by: Andrew Bresticker <abrestic@chromium.org>
