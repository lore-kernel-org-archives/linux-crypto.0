From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v3] async_pq: Remove VLA usage
Date: Fri, 1 Jun 2018 13:54:48 -0700
Message-ID: <CAPcyv4gOhnEcJuZZwCoZyMuLsA65Q0EMx1y94xMyRCySv8XcQw@mail.gmail.com>
References: <20180601202016.169085-1-ksspiers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: David Miller <davem@davemloft.net>,
        Kees Cook <keescook@chromium.org>, ray.jui@broadcom.com,
        vkoul@kernel.org, linux-crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
To: Kyle Spiers <ksspiers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180601202016.169085-1-ksspiers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jun 1, 2018 at 1:20 PM, Kyle Spiers <ksspiers@google.com> wrote:
> In the quest to remove VLAs from the kernel[1], this adjusts the
> allocation of coefs and blocks to use the existing maximum values
> (with one new define, MAX_DISKS for coefs, and a reuse of the
> existing NDISKS for blocks).
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Kyle Spiers <ksspiers@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

Vinod, will you have a chance to pick this and carry through dmaengine.git?
