From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2 4/4] fs/pstore: fs/squashfs: Change usage of LZ4 to
 comply with new LZ4 module version
Date: Sat, 7 Jan 2017 13:33:37 -0800
Message-ID: <CAGXu5jKqMUMU8DbnE=AamrCp_-JN7sGRCpaGMps16X_TshfK+Q@mail.gmail.com>
References: <1482259992-16680-1-git-send-email-4sschmid@informatik.uni-hamburg.de>
 <1483808145-18417-1-git-send-email-4sschmid@informatik.uni-hamburg.de> <1483808145-18417-5-git-send-email-4sschmid@informatik.uni-hamburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andrew Morton <akpm@linux-foundation.org>, bongkyu.kim@lge.com,
        rsalvaterra@gmail.com,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, phillip@squashfs.org.uk
To: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:35800 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751573AbdAGVdj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Jan 2017 16:33:39 -0500
Received: by mail-io0-f175.google.com with SMTP id j18so10086084ioe.2
        for <linux-crypto@vger.kernel.org>; Sat, 07 Jan 2017 13:33:39 -0800 (PST)
In-Reply-To: <1483808145-18417-5-git-send-email-4sschmid@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jan 7, 2017 at 8:55 AM, Sven Schmidt
<4sschmid@informatik.uni-hamburg.de> wrote:
> This patch updates fs/pstore and fs/squashfs to use the updated functions from
> the new LZ4 module.
>
> Signed-off-by: Sven Schmidt <4sschmid@informatik.uni-hamburg.de>
> ---
>  fs/pstore/platform.c      | 14 ++++++++------
>  fs/squashfs/lz4_wrapper.c | 12 ++++++------
>  2 files changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 729677e..a0d8ca8 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -342,31 +342,33 @@ static int compress_lz4(const void *in, void *out, size_t inlen, size_t outlen)
>  {
>         int ret;
>
> -       ret = lz4_compress(in, inlen, out, &outlen, workspace);
> +       ret = LZ4_compress_default(in, out, inlen, outlen, workspace);
>         if (ret) {
> +               // ret is 0 means an error occured

If that's true, then shouldn't the "if" logic be changed? Also, here
and in all following comments are C++ style instead of kernel C-style.
This should be "/* ret == 0 means an error occured */", though really,
that should be obvious from the code and the comment isn't really
needed.

>                 pr_err("lz4_compress error, ret = %d!\n", ret);

If it's always going to be zero here, is there a better place to get
details on why it failed?

>                 return -EIO;
>         }
>
> -       return outlen;
> +       return ret;
>  }
>
>  static int decompress_lz4(void *in, void *out, size_t inlen, size_t outlen)
>  {
>         int ret;
>
> -       ret = lz4_decompress_unknownoutputsize(in, inlen, out, &outlen);
> -       if (ret) {
> +       ret = LZ4_decompress_safe(in, out, inlen, outlen);
> +       if (ret < 0) {
> +               // return value is < 0 in case of error
>                 pr_err("lz4_decompress error, ret = %d!\n", ret);
>                 return -EIO;
>         }
>
> -       return outlen;
> +       return ret;
>  }
>
>  static void allocate_lz4(void)
>  {
> -       big_oops_buf_sz = lz4_compressbound(psinfo->bufsize);
> +       big_oops_buf_sz = LZ4_compressBound(psinfo->bufsize);
>         big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
>         if (big_oops_buf) {
>                 workspace = kmalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
> diff --git a/fs/squashfs/lz4_wrapper.c b/fs/squashfs/lz4_wrapper.c
> index ff4468b..a512399 100644
> --- a/fs/squashfs/lz4_wrapper.c
> +++ b/fs/squashfs/lz4_wrapper.c
> @@ -97,7 +97,6 @@ static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
>         struct squashfs_lz4 *stream = strm;
>         void *buff = stream->input, *data;
>         int avail, i, bytes = length, res;
> -       size_t dest_len = output->length;
>
>         for (i = 0; i < b; i++) {
>                 avail = min(bytes, msblk->devblksize - offset);
> @@ -108,12 +107,13 @@ static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
>                 put_bh(bh[i]);
>         }
>
> -       res = lz4_decompress_unknownoutputsize(stream->input, length,
> -                                       stream->output, &dest_len);
> -       if (res)
> +       res = LZ4_decompress_safe(stream->input, stream->output, length, output->length);
> +       if (res < 0) {
> +               // res of less than 0 means an error occured
>                 return -EIO;
> +       }
>
> -       bytes = dest_len;
> +       bytes = res;
>         data = squashfs_first_page(output);
>         buff = stream->output;
>         while (data) {
> @@ -128,7 +128,7 @@ static int lz4_uncompress(struct squashfs_sb_info *msblk, void *strm,
>         }
>         squashfs_finish_page(output);
>
> -       return dest_len;
> +       return res;
>  }
>
>  const struct squashfs_decompressor squashfs_lz4_comp_ops = {
> --
> 2.1.4
>

-Kees

-- 
Kees Cook
Nexus Security
