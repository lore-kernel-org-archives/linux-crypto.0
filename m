From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v4 23/27] x86_64: assembly, change all ENTRY+ENDPROC to
 SYM_FUNC_*
Date: Mon, 2 Oct 2017 14:16:16 -0400
Message-ID: <eddf0380-ba27-fa4a-a7a8-4936555bacc9@oracle.com>
References: <20171002091246.28432-1-jslaby@suse.cz>
 <20171002091246.28432-23-jslaby@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Matt Fleming <matt@codeblueprint.co.uk>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Juergen Gross <jgross@suse.com>, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-efi@vger.kernel.org,
        xen-devel@lists.xenproject.org
To: Jiri Slaby <jslaby@suse.cz>, mingo@redhat.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171002091246.28432-23-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 10/02/2017 05:12 AM, Jiri Slaby wrote:
> These are all functions which are invoked from elsewhere, so we annotate
> them as global using the new SYM_FUNC_START. And their ENDPROC's by
> SYM_FUNC_END.
>
> And make sure ENTRY/ENDPROC is not defined on X86_64, given these were
> the last users.
>
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: x86@kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: Juergen Gross <jgross@suse.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-efi@vger.kernel.org
> Cc: xen-devel@lists.xenproject.org

For Xen bits:

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
