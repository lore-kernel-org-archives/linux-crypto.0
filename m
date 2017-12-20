From: Philippe Ombredanne <pombredanne@nexb.com>
Subject: Re: [PATCH 1/2] padata: Remove FSF address
Date: Wed, 20 Dec 2017 21:20:48 +0100
Message-ID: <CAOFm3uGvuyHcKQ9vvZ1=U3D3Qp8N4npU-JSkWmyr-=9aYv=vzw@mail.gmail.com>
References: <1513800921-12452-1-git-send-email-thrust73@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: steffen.klassert@secunet.com, linux-crypto@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
To: Cheah Kok Cheong <thrust73@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:39429 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754388AbdLTUV3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 15:21:29 -0500
Received: by mail-wr0-f195.google.com with SMTP id a41so23304581wra.6
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 12:21:29 -0800 (PST)
In-Reply-To: <1513800921-12452-1-git-send-email-thrust73@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 9:15 PM, Cheah Kok Cheong <thrust73@gmail.com> wrote:
> Remove FSF address otherwise checkpatch will flag my next patch.
>
> Signed-off-by: Cheah Kok Cheong <thrust73@gmail.com>
> ---
>  kernel/padata.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 57c0074..9d91909 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -14,10 +14,6 @@
>   * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>   * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>   * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program; if not, write to the Free Software Foundation, Inc.,
> - * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
>   */
>
>  #include <linux/export.h>
> --
> 2.7.4
>


Why not use instead the simpler SPDX ids?
-- 
Cordially
Philippe Ombredanne
